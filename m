Return-Path: <linux-kernel-owner+w=401wt.eu-S1755079AbYGUVLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079AbYGUVLc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 17:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751426AbYGUVLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 17:11:24 -0400
Received: from atlantis.8hz.com ([212.129.237.78]:63101 "EHLO atlantis.8hz.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127AbYGUVLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 17:11:23 -0400
Date: Mon, 21 Jul 2008 21:11:22 +0000
From: Sean Young <sean@mess.org>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Led driver for technologic systems 5500
Message-ID: <20080721211122.GA72268@atlantis.8hz.com>
References: <20080719122339.GA28813@atlantis.8hz.com> <20080721103659.GA19498@pazke.donpac.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080721103659.GA19498@pazke.donpac.ru>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2008 at 02:36:59PM +0400, Andrey Panin wrote:
> On 201, 07 19, 2008 at 12:23:39PM +0000, Sean Young wrote:
> > Here is a patch for the led on the Technologic Systems 5500 board. Detection
> > is a bit flimsy; Is there anything that can be done about that?
> 
> Does this system contain usable DMI info ? If yes, use dmi_check_system().

Unfortunately there is no DMI whatsoever.


Sean
