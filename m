Return-Path: <linux-kernel-owner+w=401wt.eu-S1752874AbZISWnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874AbZISWnI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 18:43:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbZISWnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 18:43:08 -0400
Received: from mail-yw0-f175.google.com ([209.85.211.175]:47034 "EHLO
	mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbZISWnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 18:43:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:user-agent:x-archive:mime-version
         :content-type;
        b=Xry5FpqMmXDoO5YWjBNHr2tYejQX03q6bOYplWrd0vPfAeCLl7mwyskeLsFaolEN3b
         2679AC9xGFCprF5u7ZiCTph+xUDpbIqmQ2wnY0nzpGaSts16Z744xCG2/77eQ8/qiGCx
         R4MirD5shB0Vd74QxMGEjCaQF3SdtbVEZxzGc=
Date: Sat, 19 Sep 2009 19:43:04 -0300 (BRST)
From: "=?ISO-8859-15?Q?Fr=E9d=E9ric_L=2E_W=2E_Meunier?=" 
	<fredlwm@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: 2.6.31: no login prompt
Message-ID: <alpine.LNX.2.01.0909191941270.24796@pervalidus>
User-Agent: Alpine 2.01 (LNX 1184 2008-12-16)
X-Archive: encrypt
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While booting 2.6.31, I don't get a login prompt after runlevel 
3:

Sep 19 18:31:25 pervalidus init: Id "c1" respawning too fast: disabled for 5 minutes
Sep 19 18:31:25 pervalidus init: Id "c3" respawning too fast: disabled for 5 minutes
Sep 19 18:31:25 pervalidus init: Id "c2" respawning too fast: disabled for 5 minutes

It works fine with 2.6.30.5.

What can be causing it ?
