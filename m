Return-Path: <linux-kernel-owner+w=401wt.eu-S1755852Ab0A1Qvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755852Ab0A1Qvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 11:51:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755628Ab0A1Qvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 11:51:45 -0500
Received: from mail.codesourcery.com ([38.113.113.100]:42373 "EHLO
	mail.codesourcery.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571Ab0A1Qvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 11:51:45 -0500
From: Paul Brook <paul@codesourcery.com>
Organization: CodeSourcery
To: Corentin Chary <corentin.chary@gmail.com>
Subject: Re: [PATCH] EeePC 1005PE rfkill fix
Date: Thu, 28 Jan 2010 16:50:53 +0000
User-Agent: KMail/1.12.4 (Linux/2.6.32-trunk-amd64; KDE/4.3.4; x86_64; ; )
Cc: acpi4asus-user@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux acpi <linux-acpi@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
References: <201001281253.54878.paul@codesourcery.com> <71cd59b01001280526m54ddbd82t7803629a2149fa2c@mail.gmail.com>
In-Reply-To: <71cd59b01001280526m54ddbd82t7803629a2149fa2c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001281650.53913.paul@codesourcery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> First did you try your patch with an updated bios ?

Good point. The updated bios seems to behave better (the same as the 1005HA), 
so consider the original patch withdrawn.  We just need to add 1005PE to the 
existing blacklist.

Paul
