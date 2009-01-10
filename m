Return-Path: <linux-kernel-owner+w=401wt.eu-S1754213AbZAJGAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbZAJGAJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 01:00:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751176AbZAJF74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 00:59:56 -0500
Received: from rn-out-0910.google.com ([64.233.170.189]:53084 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbZAJF74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 00:59:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=BNIf5ZQIFRp28r1/1o6t5a57ceu6RvNYJvOJ28DvOEzdKHQmN14W+BUo7XIbY0AIuI
         gCc6BGXMOiR3evv2TzpR6wf3UG2crtFJtx3WUoMxVbeCpSXLjMG89JGupdlxyYyrut5p
         dZabejgpcxfD6tWXTuVJDUV0hsn04CtpbYilQ=
Message-ID: <49683957.9070700@gmail.com>
Date: Fri, 09 Jan 2009 21:59:51 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am seeing this in dmesg:
FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
not sure what this is.
(the only changes to .config was add kexec,
coredump, and relocatable kernel options.)

I take it that I'm unable to try this relocatable
kernel stuff out.(x86_32)?

regards;

Justin P. Mattock
