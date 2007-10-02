Return-Path: <linux-kernel-owner+w=401wt.eu-S1756572AbXJCFIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572AbXJCFIk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 01:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751150AbXJCFIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 01:08:32 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:33437 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751016AbXJCFIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 01:08:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=NzAtT9lO9QtVTn7c19mp2ioAGynzazQ0IxUay1IHZkLp4jbqyC1ghhpCIEMWZwSaHL4g52WuWY0LOabeNoiiIUmS8/hMtKZ1AH7Bu2TqUHW+a6bVd+o49fbxq9zgMX5Cw+B1t/ugyAXYJ/jYD/aatZCCw7IokaAmbgJG8WPZu/c=  ;
X-YMail-OSG: T2LqggAVM1mt7DAMFrfchahp3ANdySW1Rfv5C3OsO4sVP62aZnZa_.lhrV68RBWIbYBHlpj_QyDb9_gMcwpTSSurqWAKezn7maVzD42frVWuhCtWO8A-
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Paul Jackson <pj@sgi.com>
Subject: Re: wibbling over the cpuset shed domain connnection
Date: Tue, 2 Oct 2007 22:36:59 +1000
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org> <20071001143443.b873f70d.pj@sgi.com>
In-Reply-To: <20071001143443.b873f70d.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710022236.59583.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 October 2007 07:34, Paul Jackson wrote:
> In -mm merge plans for 2.6.24, Andrew wrote:
> > cpuset-remove-sched-domain-hooks-from-cpusets.patch
> >
> >   Paul continues to wibble over this.  Hold, I guess.
>
> Oh dear ... after looking at the following to figure out what
> a wibble is, I wonder which one Andrew had in mind:
>
>   http://www.urbandictionary.com/define.php?term=wibble
>
> The insanity, the rubbish, being overwhelmed, ... ?
>
> <grin>
>
> If one of Nick or I can knock some sense into the others head,
> then this saga should come to a close soon.

In the meantime, that patch should be merged though, shouldn't it?
cpusets is currently telling the scheduler to do the wrong thing WRT
the user interface definition of cpusets, right?
