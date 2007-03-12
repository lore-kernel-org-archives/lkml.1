Return-Path: <linux-kernel-owner+w=401wt.eu-S932536AbXCLV7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932536AbXCLV7z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 17:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932189AbXCLV7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 17:59:55 -0400
Received: from ozlabs.org ([203.10.76.45]:35581 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932536AbXCLV7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 17:59:54 -0400
Subject: Re: _proxy_pda still makes linking modules fail
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       "Marcin 'Qrczak' Kowalczyk" <qrczak@knm.org.pl>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070312094805.GA11644@one.firstfloor.org>
References: <1173315479.12472.9.camel@qrnik>
	 <p73lki39s3a.fsf@bingen.suse.de> <45F49E0A.3090607@goop.org>
	 <20070312094805.GA11644@one.firstfloor.org>
Content-Type: text/plain
Date: Tue, 13 Mar 2007 08:58:46 +1100
Message-Id: <1173736726.10618.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-12 at 10:48 +0100, Andi Kleen wrote:
> > Rusty's pda->per_cpu patch will deal with this once and for all; have
> 
> Not on x86-64.

Indeed.  Perhaps it's time I join the modern world and compile a 64-bit
kernel...

Will prepare patches,
Rusty.


