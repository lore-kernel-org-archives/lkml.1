Return-Path: <linux-kernel-owner+w=401wt.eu-S936893AbYD1U1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936893AbYD1U1b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 16:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765500AbYD1U1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 16:27:22 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:50817 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933104AbYD1U1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 16:27:22 -0400
Date: Mon, 28 Apr 2008 22:27:55 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scripts/kconfig/lxdialog/inputbox.c: reversed draw_box(dlg.border.atr and dlg.dialog.atr) in dialog_inputbox()
Message-ID: <20080428202755.GA18248@uranus.ravnborg.org>
References: <47E2C968.8020102@tiscali.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E2C968.8020102@tiscali.nl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2008 at 09:30:32PM +0100, Roel Kluin wrote:
> Not tested, please confirm it's right.
> ---
> Fix reversal of dlg.border.atr and dlg.dialog.atr for draw_box()
> 
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>

Thanks Roel.
Tested and applied.

	Sam
