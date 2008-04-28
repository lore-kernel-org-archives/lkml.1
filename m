Return-Path: <linux-kernel-owner+w=401wt.eu-S937159AbYD1VYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937159AbYD1VYu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 17:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932105AbYD1VYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 17:24:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55795
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932076AbYD1VYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 17:24:38 -0400
Date: Mon, 28 Apr 2008 14:24:37 -0700 (PDT)
Message-Id: <20080428.142437.95420358.davem@davemloft.net>
To: auke-jan.h.kok@intel.com
Cc: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com
Subject: Re: [PATCH] e1000e triggers sparc32 gcc bug
From: David Miller <davem@davemloft.net>
In-Reply-To: <48160CBA.4010504@intel.com>
References: <20080427051541.GN5882@ZenIV.linux.org.uk>
	<20080426.221908.193700782.davem@davemloft.net>
	<48160CBA.4010504@intel.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kok, Auke" <auke-jan.h.kok@intel.com>
Date: Mon, 28 Apr 2008 10:43:22 -0700

> wow, that's pretty bad - anything I can do? We're severely limited in sparc
> systems here...

Al caught this with a cross-compile :-)

Don't worry about this, I or someone else will try to get it fixed
up somehow.

