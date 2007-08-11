Return-Path: <linux-kernel-owner+w=401wt.eu-S1764274AbXHKWrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764274AbXHKWrc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 18:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762390AbXHKWrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 18:47:23 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:63253 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762020AbXHKWrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 18:47:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=Z1BFwADAuL0VMtTX3oKe16xbdy7R7SbYaVjyXWVt6Cah9Sq8H0AQJO0gL7CNtMTXCJgqjwzLsYfShSPODXzLE5ql4Z9AYNmVIuNyq3YCclN5mcGGlDTC2ZC3x84z3gOFfySPqumVMv0VRPosu+Q82oOM9s91bOT1lvowNQq5G8E=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: linux-doc@vger.kernel.org
Subject: [PATCH 0/5] Add some missing Documentation/*/00-INDEX files
Date: Sun, 12 Aug 2007 00:45:02 +0200
User-Agent: KMail/1.9.7
Cc: Rob Landley <rob@landley.net>, Randy Dunlap <rdunlap@xenotime.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200708120045.03032.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Rob Landley is trying to organize Linux kernel documentation. One 
thing he is doing is generating index.html files based on our 
00-INDEX files in the Documentation directory. He has met with a 
small problem however, since not all subdirectories inside 
Documentation contain such a file, nor are all the files that do 
exist up to date, his index.html files turn up rather incomplete.

In a reply to a recent post to linux-doc, where Rob also posted his 
script for generating the index.html files, I offered to help out 
with that situation and create (at least some of) the missing 
00-INDEX files. These patches represent the first five files I've 
created.
The reason I'm not submitting more files at this time is simply 
that I want to get some feedback before wasting too much time 
creating these files if it turns out that for some reason they are 
not wanted. This is also the reason why I'm cross posting to LKML 
at this time, since I suspect that not very many people currently 
read linux-doc.

So please do the ACK/NACK/Merge dance with these patches and 
let me know if more are wanted or not. :-)


Kind regards,
  Jesper Juhl <jesper.juhl@gmail.com>


