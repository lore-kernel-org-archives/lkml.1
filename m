Return-Path: <linux-kernel-owner+w=401wt.eu-S1756798AbYABPPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798AbYABPPS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 10:15:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753446AbYABPPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 10:15:08 -0500
Received: from main.gmane.org ([80.91.229.2]:40690 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489AbYABPPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 10:15:06 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Niels de Vos <niels.devos@wincor-nixdorf.com>
Subject: Re: [PATCH] Get NUMLOCK from PC BIOS
Date: Wed, 2 Jan 2008 15:11:15 +0000 (UTC)
Message-ID: <loom.20080102T150709-806@post.gmane.org>
References: <alpine.LSU.0.999.0712301230270.3273@be1.lrz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 217.115.67.74 (Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.8) Gecko/20071004 Iceweasel/2.0.0.8 (Debian-2.0.0.8-1))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	  If you have an alternative firmware like OpenFirmware or LinuxBios,
> +	  this flag might not be set correctly, which results in a random state
> +	  of the Numlock key.

Looks good. But would it not be helpfull to have a kernel-parameter for
overruling the BIOS-setting?

Cheers,
Niels

