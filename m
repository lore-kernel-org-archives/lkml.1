Return-Path: <linux-kernel-owner+w=401wt.eu-S966043AbXDBWuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966043AbXDBWuI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 18:50:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966050AbXDBWti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 18:49:38 -0400
Received: from smtp108.sbc.mail.mud.yahoo.com ([68.142.198.207]:32379 "HELO
	smtp108.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S966002AbXDBWt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 18:49:27 -0400
X-YMail-OSG: P4Ss2dAVM1lgPiouEoao7VJFXqi9xZh_0reH5OLlBStObUbrCrIY3q_nnaBmlD.H_2IX3IYKWQ--
Date: Mon, 2 Apr 2007 15:49:23 -0700
From: Chris Wedgwood <cw@f00f.org>
To: Tom Strader <tom.strader@xilinx.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Warning: unable to open an initial console.
Message-ID: <20070402224923.GA11208@tuatara.stupidest.org>
References: <20070402190458.0EDD039005F@mail42-fra.bigfish.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070402190458.0EDD039005F@mail42-fra.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2007 at 12:04:56PM -0700, Tom Strader wrote:

> I have seen quite a few posts regarding unable to open an initial
> console, but my system seems to have the necessary things in place
> so I come looking for help.

your rootfs/initramfs/initrd is missing a valid working /dev/console

> VFS: Mounted root (jffs2 filesystem).

check /dev/ on this filesystem
