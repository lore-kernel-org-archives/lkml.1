Return-Path: <linux-kernel-owner+w=401wt.eu-S1752266AbZKMFad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266AbZKMFad (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 00:30:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750913AbZKMFa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 00:30:28 -0500
Received: from senator.holtmann.net ([87.106.208.187]:52504 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbZKMFa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 00:30:28 -0500
Subject: Re: [patch 0/1] Adding radio type FM
From: Marcel Holtmann <marcel@holtmann.org>
To: Janakiram Sistla <janakiram.sistla@gmail.com>
Cc: Julian Calaby <julian.calaby@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <4fb5db50911122119j1271a5f4ra718aa8fb34f9bff@mail.gmail.com>
References: <4fb5db50911121909h1619e483ga4aa395af8fc1161@mail.gmail.com>
	 <20091113030950.GB4054@tuxdriver.com>
	 <4fb5db50911121925t1a6770ddtbd5f01477470046d@mail.gmail.com>
	 <646765f40911121929p5aa416c3o99f33bd5b5d8c5cb@mail.gmail.com>
	 <1258083706.7715.16.camel@violet>
	 <646765f40911121945p7080b920s230b92fb02b04ae7@mail.gmail.com>
	 <4fb5db50911122119j1271a5f4ra718aa8fb34f9bff@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Nov 2009 06:30:26 +0100
Message-ID: <1258090226.3299.1.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Janakiram,

> Thankyou for all the comments on the patch.Yes if you see the toshiba
> Laptop series which have an FM key that enables FM.If still People say
> that we cannot take KEY_FM yes we will go ahead and will resubmit a
> patch with only RFKILL for FM

how is that key mapped in reality? Or is that just a KEY_RFKILL toggle
sort of key.

Submit the patch without the input modifications since that can be acked
right away. And don't forget to send a patch for rfkill utility that
adds FM support.

Regards

Marcel


