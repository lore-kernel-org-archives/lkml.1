Return-Path: <linux-kernel-owner+w=401wt.eu-S932436AbZKDRlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436AbZKDRlW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:41:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932327AbZKDRlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:41:17 -0500
Received: from outbound-mail-135.bluehost.com ([67.222.39.25]:40580 "HELO
	outbound-mail-135.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932308AbZKDRlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:41:14 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=h0mmQADVjVzgn8kWh6lq7Ghlk+BXpdQGA1Dp4C3vjRwF97NvekPecmhDDrHxDNlBO65CuuC0UG2Eb2R5EkEIVsJr5aYbKmvZJIJyT7R05/Xg4A+OqCSjWfqTHp4M3zQc;
Date: Wed, 4 Nov 2009 09:41:17 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alex Chiang <achiang@hp.com>
Cc: linux-pci <linux-pci@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PCI Hotplug: acpiphp: clean up list traversals
Message-ID: <20091104094117.45a383b3@jbarnes-piketon>
In-Reply-To: <20091027032527.GB30509@ldl.fc.hp.com>
References: <20091027032527.GB30509@ldl.fc.hp.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Oct 2009 21:25:27 -0600
Alex Chiang <achiang@hp.com> wrote:

> Using list_for_each_entry instead of list_for_each allows us to
> enhance readability and minorly reduce some stack usage.
> 
> Signed-off-by: Alex Chiang <achiang@hp.com>
> ---
> This is 2.6.33 material, thanks.

Applied to linux-next, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
