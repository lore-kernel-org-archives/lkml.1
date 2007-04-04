Return-Path: <linux-kernel-owner+w=401wt.eu-S2992522AbXDDCvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992522AbXDDCvK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 22:51:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992531AbXDDCvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 22:51:10 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:22851 "EHLO
	asav08.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992522AbXDDCvI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 22:51:08 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAICuEkZKhRO4UGdsb2JhbACPfgEBGyM
From: Dmitry Torokhov <dtor@insightbb.com>
To: Karl Pickett <karl.pickett@gmail.com>
Subject: Re: [PATCH] Make ati_remote button repeat sensitivity soft-configurable
Date: Tue, 3 Apr 2007 22:51:06 -0400
User-Agent: KMail/1.9.3
Cc: linux-kernel@vger.kernel.org, linux-input@atrey.karlin.mff.cuni.cz
References: <f9be06770704031734k11ec894fpdf1afe385108aece@mail.gmail.com>
In-Reply-To: <f9be06770704031734k11ec894fpdf1afe385108aece@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="windows-1252"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200704032251.06396.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Karl,

On Tuesday 03 April 2007 20:34, Karl Pickett wrote:
> The ati_remote driver is a little too sensitive for my wife... if you
> do anything but barely tap the button you can get multiple events
> reported.  We prefer a more conservative no-repeat setting.  This is a
> pretty trivial patch which just makes one hard coded value soft
> configurable and does not change the default.
> 

Makes sense. Can I please have a Signed-off-by: ... line from you so
I can apply the patch to my tree?

Thanks!

-- 
Dmitry
