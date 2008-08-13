Return-Path: <linux-kernel-owner+w=401wt.eu-S1755523AbYHMSth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523AbYHMSth (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 14:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbYHMSt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 14:49:29 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:56758 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbYHMSt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 14:49:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=IrXw0bQ2Df+CuFP1H7LGNr8VMaBQ7QodtlEYOj2g6SwbxNcHtb/lQKt766ZKxt84dK
         u+yO7Qmy2iQ3LwlLLrPFbGpZE/XY8PMkPK7YhjNz7GhIsN0+NeeJ/QO11/PgkXG4GOYo
         hCAHMtF37O37pE1tIamtNpsKZvxlB+aJMKg0w=
Message-ID: <48A32CAC.1030605@gmail.com>
Date: Wed, 13 Aug 2008 14:49:16 -0400
From: 7v5w7go9ub0o <7v5w7go9ub0o@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: re: libmalware.so: Dazuko Linux/BSD On-Access scanning and control
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(FYI. Dazuko may have trailblazed some of the issues now under 
discussion re: libmalware.so. It has worked well for me. It used to be 
an LKM, it is now a source patch. It is used in a number of commercial 
products)


<http://dazuko.dnsalias.org/wiki/index.php/Main_Page>

"A Virtual Device Driver to Allow Online File Access Control

A common interface is needed, which allows userland applications to
perform online file access control. Dazuko aims to provide that interface."

FWIW, I'm not associated with Dazuko or Antivir; I've been happily using
Dazuko with AntiVir for a year or so.

1. AntiVir includes numerous Linux signatures as well as Windows. So I
scan both 'ix downloads, as well as the process of compiling new software.

2. Other AntiMalwares are using Dazuko, though many are scanning for 
Windows malware only.

3. The AntiVir/Dazuko combination with full heuristics has blocked
access to clearly dangerous JS scripts in my browser cache.

4. IMHO, what is needed is a Dazuko or libmalware/Integrity database 
link. If an md5 of an executable or script is new or has changed, access 
is blocked 'til a response to a popup is given. Access can be blocked; 
one-time allowed; or permanently allowed, in which case the md5 is updated.

Hope This Helps.



