Return-Path: <linux-kernel-owner+w=401wt.eu-S1757777AbYFUCF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777AbYFUCF3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 22:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbYFUCFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 22:05:19 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:19032 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010AbYFUCFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 22:05:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=RTdIWy/L+UcpUDBdfBAY4lXDnntAIYGxK5GpNiC28ekUfzctctGYkWxEPqDi3myPsc
         I6ooZPc3wb6bIRcQLkcag1BsfxEWQ1d/cFUy5xWOreyPmGhha8B8+DjMfX5QhmLoqPuh
         BK97JtHfRRqhya3Iqr9d2B4DsMUQWMjdAPgEk=
Message-ID: <dd18b0c30806201905n65b308d7ua20a5a704bee11a1@mail.gmail.com>
Date: Sat, 21 Jun 2008 02:05:16 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: hda_intel: azx_get_response timeout, switching to polling mode: last cmd=0x011f000c
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello; I sent a post last week reporting with 2.6.26-rc6 about:
[  138.057543] hda_intel: azx_get_response timeout, switching to
polling mode: last cmd=0x011f000c

I've just loaded 2.6.26-rc7 and am now seeing this quite often, with
2.6.26-rc6 very seldom,
I've reboot twice and both times this appeared.
regards;


-- 
Justin P. Mattock
