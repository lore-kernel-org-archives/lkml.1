Return-Path: <linux-kernel-owner+w=401wt.eu-S1761936AbYA3LYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761936AbYA3LYj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 06:24:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756721AbYA3LYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 06:24:31 -0500
Received: from ozlabs.org ([203.10.76.45]:44008 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753674AbYA3LYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 06:24:30 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: ndiswrapper and GPL-only symbols redux
Date: Wed, 30 Jan 2008 22:24:27 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       Jon Masters <jonathan@jonmasters.org>,
       Giridhar Pemmasani <pgiri@yahoo.com>
References: <1201641765.18773.35.camel@dv> <20080130002514.GA1802@does.not.exist> <1201658555.24898.27.camel@dv>
In-Reply-To: <1201658555.24898.27.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801302224.28115.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think you'd be impressed at how little I care about this, and how little I 
value my fellow hacker's legal opinions except for humor value.

Let ndiswrapper do the taint itself, let's revert the patch and add a damn 
comment: Jon was right to clean up such unexplained crap.

Rusty.
