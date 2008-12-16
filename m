Return-Path: <linux-kernel-owner+w=401wt.eu-S1756694AbYLPNf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694AbYLPNf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 08:35:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753340AbYLPNfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 08:35:18 -0500
Received: from styx.suse.cz ([82.119.242.94]:58735 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753038AbYLPNfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 08:35:17 -0500
Date: Tue, 16 Dec 2008 14:35:16 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Hannes Eder <hannes@hanneseder.net>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] HID: avoid sparse warning in HID_COMPAT_LOAD_DRIVER
In-Reply-To: <4947a48f.08b6660a.34ca.ffffa1e8@mx.google.com>
Message-ID: <alpine.LNX.1.10.0812161434150.21089@jikos.suse.cz>
References: <4947a48f.08b6660a.34ca.ffffa1e8@mx.google.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2008, Hannes Eder wrote:

> Impact: include a prototype for the exported function in the macro
> 
> Fix about 20 of this warnings:
> 
>   drivers/hid/hid-a4tech.c:162:1: warning: symbol 'hid_compat_a4tech' was not declared. Should it be static?
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
