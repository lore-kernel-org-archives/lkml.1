Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949Ab0BMWoP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 17:44:15 -0500
Received: from mail-yw0-f179.google.com ([209.85.211.179]:56777 "EHLO
	mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab0BMWoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 17:44:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=j2pGeCAICfn8QjQMye0ZK8eq09+IMX9vMgSF4Wnm226gSlL7glEznhTxh5JrbFBWLp
         xpdSNzSeWFvMomtGLb+X7JP0zcQpmjGyloRgCGvt4MkvEgCPwGzpN7sNo3ms1OJa5tHe
         nap37sDyeOKTZdfP0dubwqs8G5wXi1g3/bZPU=
Message-ID: <4B772B3A.6030202@garzik.org>
Date: Sat, 13 Feb 2010 17:44:10 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: [PATCH 2/3] pata_pdc202xx_old: fix UDMA mode for PDC2026x chipsets
References: <20100213133538.11564.94218.sendpatchset@localhost> <20100213133559.11564.54028.sendpatchset@localhost> <201002131444.58139.bzolnier@gmail.com>
In-Reply-To: <201002131444.58139.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2010 08:44 AM, Bartlomiej Zolnierkiewicz wrote:
> .sff_exec_command	= pdc202xx_exec_command,

applied patch #2 + this missing chunk

