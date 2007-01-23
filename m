Return-Path: <linux-kernel-owner+w=401wt.eu-S932299AbXAWGWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299AbXAWGWJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 01:22:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933073AbXAWGWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 01:22:08 -0500
Received: from main.gmane.org ([80.91.229.2]:51812 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932299AbXAWGWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 01:22:07 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Oleg Verych <olecom@flower.upol.cz>
Subject: Re: [PATCH] kbuild: Replace remaining "depends" with "depends on"
Date: Tue, 23 Jan 2007 06:21:51 +0000 (UTC)
Organization: Palacky University in Olomouc, experimental physics department.
Message-ID: <slrnerbas3.e7s.olecom@flower.upol.cz>
References: <Pine.LNX.4.64.0612130735450.31075@localhost.localdomain>
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: flower.upol.cz
User-Agent: slrn/0.9.8.1pl1 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2006-12-13, Robert P. J. Day wrote:
>
>   Replace the very few remaining "depends" Kconfig directives with
> "depends on".
>
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
>
> ---

For this kind of fixes, please use
"kconfig" subsystem instead of
"kbuild" in subject. Thanks.

____

