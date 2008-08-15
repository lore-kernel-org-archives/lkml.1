Return-Path: <linux-kernel-owner+w=401wt.eu-S1758914AbYHOSu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758914AbYHOSu2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 14:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879AbYHOSuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 14:50:16 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:34706 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680AbYHOSuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 14:50:15 -0400
In-Reply-To: <e7d8f83e0808150337t5e699647wcc6ae296b3fa8c23@mail.gmail.com>
Subject: Re: [PATCH 1/4] integrity: TPM internel kernel interface
To: "Peter Dolding" <oiaohm@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OF1D7319B5.AB5A1EFB-ON852574A6.0066E026-852574A6.006775BA@us.ibm.com>
From: Kenneth Goldman <kgoldman@us.ibm.com>
Date: Fri, 15 Aug 2008 14:50:01 -0400
X-MIMETrack: Serialize by Router on D01ML604/01/M/IBM(Build V85_M1_05262008|May 26, 2008) at
 08/15/2008 14:50:01
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Peter Dolding" <oiaohm@gmail.com> wrote on 08/15/2008 06:37:27 AM:

> Remember even soldered on stuff can fail.   How linux handles the
> death of the TPM module needs to be covered.

Is fault tolerance a requirement just for the TPM, or is it a general>
Linux requirement?  Has it always been there, or is it new?

For example, does kernel software have to gracefully handle
failures in the disk controller, processor, memory controller, BIOS
flash memory, etc?

I'd think it would be quite hard to code around motherboard
failures in a commodity platform not designed for fault tolerance.

