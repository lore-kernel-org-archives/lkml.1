Return-Path: <linux-kernel-owner+w=401wt.eu-S1030181AbXBFWk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030181AbXBFWk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 17:40:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030183AbXBFWk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 17:40:28 -0500
Received: from main.gmane.org ([80.91.229.2]:44245 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030181AbXBFWk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 17:40:27 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
Subject: Re: [2.6.20] Regression in dmfe driver
Date: Tue, 06 Feb 2007 23:40:04 +0100
Message-ID: <eqb044$rn5$1@sea.gmane.org>
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org>	<eq87gu$5vo$1@sea.gmane.org> <m27iuvhbhc.fsf@vador.mandriva.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: port-83-236-74-197.dynamic.qsc.de
User-Agent: Thunderbird 1.5.0.9 (X11/20070124)
In-Reply-To: <m27iuvhbhc.fsf@vador.mandriva.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thierry Vignaud schrieb:
> disable link detection in your network config then (eg:
> MII_NOT_SUPPORTED=yes in ifcfg-XXX depending on the distro).

I don't have such an option in "my distro". What does it do and how
would it change the fact that TX is being disabled in the driver?

