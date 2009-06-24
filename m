Return-Path: <linux-kernel-owner+w=401wt.eu-S1753874AbZFXVEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbZFXVEf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 17:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751058AbZFXVE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 17:04:28 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33974 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbZFXVE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 17:04:28 -0400
Date: Wed, 24 Jun 2009 22:04:30 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Build failure latest git. (acl related)
Message-ID: <20090624210430.GW8633@ZenIV.linux.org.uk>
References: <20090624200941.GA30531@phenom2.trippelsdorf.de> <20090624202852.GA31192@phenom2.trippelsdorf.de> <20090624203330.GS8633@ZenIV.linux.org.uk> <20090624204658.GB31192@phenom2.trippelsdorf.de> <20090624204906.GV8633@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090624204906.GV8633@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 09:49:06PM +0100, Al Viro wrote:

> Actually, I disagree with that one - it begs for a helper function instead
> of ifdef.  Give me a few...

Same tree, same branch...
