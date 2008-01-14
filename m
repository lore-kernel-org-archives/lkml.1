Return-Path: <linux-kernel-owner+w=401wt.eu-S1754532AbYANTqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbYANTqg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 14:46:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbYANTq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 14:46:28 -0500
Received: from smtp-107-backup.nerim.net ([62.4.16.107]:53784 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751076AbYANTq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 14:46:27 -0500
Date: Mon, 14 Jan 2008 20:46:25 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Cc: "Geert Uytterhoeven" <Geert.Uytterhoeven@sonycom.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       i2c@lm-sensors.org
Subject: Re: [i2c] [PATCH] update module-init-tools to support the i2c
 subsystem
Message-ID: <20080114204625.07293dce@hyperion.delvare>
In-Reply-To: <3ae72650801141138t27666bcerd66e96f836d1ab2b@mail.gmail.com>
References: <9e4733910712171839h214e0bc3q179266c86e5987b1@mail.gmail.com>
	<9e4733910801130714m1be16826jf240171972324d16@mail.gmail.com>
	<20080113163543.16e3d26b@hyperion.delvare>
	<9e4733910801130826l799e4897pe7380ccb973b5fd0@mail.gmail.com>
	<20080113184337.5d4cd546@hyperion.delvare>
	<9e4733910801131004i669276e2pde04b195dd10bd90@mail.gmail.com>
	<Pine.LNX.4.64.0801141154420.3058@vixen.sonytel.be>
	<20080114173835.5fe907db@hyperion.delvare>
	<Pine.LNX.4.64.0801141752450.3058@vixen.sonytel.be>
	<20080114185056.05b75fd1@hyperion.delvare>
	<3ae72650801141138t27666bcerd66e96f836d1ab2b@mail.gmail.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jan 2008 20:38:28 +0100, Kay Sievers wrote:
> On Jan 14, 2008 6:50 PM, Jean Delvare <khali@linux-fr.org> wrote:
> > I am under the impression that modules.*map are the old way to get
> > automatic driver loading and aliases are the new way to do the same.
> > But maybe that's just me.
> 
> Right, nothing on recent systems is using the map files. This patch
> should not be needed.
> The plan is to deprecate the creation of these files in depmod.

OK, great. Thanks for the info, Kay!

-- 
Jean Delvare
