Return-Path: <linux-kernel-owner+w=401wt.eu-S1753718AbXJJHXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbXJJHXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 03:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbXJJHXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 03:23:05 -0400
Received: from web52907.mail.re2.yahoo.com ([206.190.49.17]:28850 "HELO
	web52907.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751925AbXJJHXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 03:23:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=S3zYuCvPySiG7zHSrHhy+nne5GlV8zZis4IKKC5dQYxVl1GwDDFRwJ13Dbep9LVy+RICUW0mbbh2Wrd84AlTUx/VuPbsgqsAXVEdUQIgEDpjyxdFK8UoI2k7Y5kLwRU10EmY2R5bpyLJND7X4w/NnjDfcDnHKopiU2AvqdjQ2Q4=;
X-YMail-OSG: oPEo500VM1nKWB9Tw4wbs3kH.Dl4OiC.PQlLZbi.UgGIBDk3y7ofSJ6be0Zx0mEq3Q--
Date: Wed, 10 Oct 2007 08:23:02 +0100 (BST)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: [BUG] The return of the sysfs oops
To: Tejun Heo <htejun@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <470C37FA.8060706@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <171846.76044.qm@web52907.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- Tejun Heo <htejun@gmail.com> wrote:
> This isn't really related to sysfs.  It seems module count was too low
> and went away while there still were holders.  What were you doing when
> it happened?  Can you reproduce it?

I haven't tried reproducing it, but all I was doing was selecting the Audio tab in winecfg again
(exactly as with bug #8198).

Cheers,
Chris



      ______________________________________________________
Yahoo! Mail now has unlimited storage, which means you can have spam control and more space for those important e-mails.
http://uk.mail.yahoo.com
