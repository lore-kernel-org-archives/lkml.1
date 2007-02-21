Return-Path: <linux-kernel-owner+w=401wt.eu-S1750735AbXBUXB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750735AbXBUXB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 18:01:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750754AbXBUXB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 18:01:57 -0500
Received: from coyote.holtmann.net ([217.160.111.169]:44085 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbXBUXB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 18:01:56 -0500
Subject: Re: Phis in /proc/bus/input/devices same for all devices?
From: Marcel Holtmann <marcel@holtmann.org>
To: CIJOML <cijoml@volny.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200702220000.21965.cijoml@volny.cz>
References: <200702212313.30359.cijoml@volny.cz>
	 <d120d5000702211448s7d3569cdl1fdcb71d13c3c3ff@mail.gmail.com>
	 <1172098430.7403.54.camel@violet>  <200702220000.21965.cijoml@volny.cz>
Content-Type: text/plain
Date: Thu, 22 Feb 2007 00:02:37 +0100
Message-Id: <1172098957.7403.60.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

> how can you differ what is src and what is dst, when device can connect 
> first time from hub to keyboard and later keyboard to hub?

the source is always the host (meaning the adapter) and the destination
is always the device.

Regards

Marcel


