Return-Path: <linux-kernel-owner+w=401wt.eu-S1751277AbXBMLfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751277AbXBMLfd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 06:35:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbXBMLfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 06:35:33 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42404 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbXBMLfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 06:35:33 -0500
Subject: Re: dvb shared datastructure bug?
From: Arjan van de Ven <arjan@infradead.org>
To: Marcel Siegert <mws@linuxtv.org>
Cc: mchehab@infradead.org, v4l-dvb-maintainer@linuxtv.org,
       linux-kernel@vger.kernel.org, Manu Abraham <abraham.manu@gmail.com>
In-Reply-To: <200702131204.47314.mws@linuxtv.org>
References: <1171352878.12771.30.camel@laptopd505.fenrus.org>
	 <200702131204.47314.mws@linuxtv.org>
Content-Type: text/plain
Organization: Intel International BV
Date: Tue, 13 Feb 2007 12:35:26 +0100
Message-Id: <1171366526.12771.99.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> attached find a patch that fixes the problem.


Hi,

Thank you for the quick response.
I think there is a small bug in this; at least I don't see where you
copy over the content of the fops template to the newly allocated piece
of memory...

Greetings,
   Arjan van de Ven
-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

