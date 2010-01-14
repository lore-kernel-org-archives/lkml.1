Return-Path: <linux-kernel-owner+w=401wt.eu-S1751306Ab0ANFRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306Ab0ANFRg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 00:17:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751049Ab0ANFRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 00:17:34 -0500
Received: from senator.holtmann.net ([87.106.208.187]:57882 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab0ANFRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 00:17:32 -0500
Subject: Re: [PATCH] firmware_class: remove base.h header inclusion
From: Marcel Holtmann <marcel@holtmann.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: greg@kroah.com, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, mcgrof@gmail.com,
       Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1263435495-10966-1-git-send-email-lrodriguez@atheros.com>
References: <1263435495-10966-1-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Jan 2010 21:16:06 -0800
Message-ID: <1263446166.922.20.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luis,

> base.h is used by base drivers for sharing internal structures.
> Turns out firmware_class does not depend on it at all so remove it.
> 
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel


