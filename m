Return-Path: <linux-kernel-owner+w=401wt.eu-S1760700AbXHOQCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760700AbXHOQCx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 12:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755375AbXHOQCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 12:02:43 -0400
Received: from web52501.mail.re2.yahoo.com ([206.190.48.184]:31294 "HELO
	web52501.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755260AbXHOQCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 12:02:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=tccoluM9r2XOcoWZl9rhznHz6g7yCqNqpjAz9tDysNfBLplqNReH88ekrv1kWi0IadWJhCdsfn/e+4LigDzJacbOLfbeedlddrl4sl0RTWhhGKJYYDdwpg8zPytqs9W4d0bR2zMb2b3Pnol/9Q1mUSnlFxW2TT4rn21hflMaIqw=;
X-YMail-OSG: ZA3jUF8VM1kW9837TibI..d0HtjM_OChILqhpRLHAcfkhQatEZWf3Mx98sFPnfd_Og--
Date: Wed, 15 Aug 2007 09:02:41 -0700 (PDT)
From: Marc Perkel <mperkel@yahoo.com>
Subject: Re: Thinking outside the box on file systems
To: Kyle Moffett <mrmacman_g4@mac.com>,
       Michael Tharp <gxti@partiallystapled.com>
Cc: alan <alan@clueserver.org>, Marc Perkel <mperkel@yahoo.com>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
In-Reply-To: <ECFEFFF7-0210-4D16-B508-5284FCE58B28@mac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <16329.19717.qm@web52501.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Kyle Moffett <mrmacman_g4@mac.com> wrote:

> 
> ## Note: file owner and group are kmoffett
> u::rw-
> g::rw-
> u:lsorens:rw-
> u:mtharp:rw-
> u:mperkel:rw-
> g:randomcvsdudes:r-
> default:u::rw-
> default:g::rw-
> default:u:lsorens
> default:u:mtharp:rw-
> default:u:mperkel:rw-
> default:g:randomcvsdudes:r-

Kyle, thinking further outside the box, files would no
longer have owners or permissions. Nor would
directories. People, groups, managers, and other
objects with have permissions. One might tag a file
with the object that created it so you could implement
"self" rights which might be use to replace the
concept of /tmp directories. 


Marc Perkel
Junk Email Filter dot com
http://www.junkemailfilter.com


       
____________________________________________________________________________________
Got a little couch potato? 
Check out fun summer activities for kids.
http://search.yahoo.com/search?fr=oni_on_mail&p=summer+activities+for+kids&cs=bz 
