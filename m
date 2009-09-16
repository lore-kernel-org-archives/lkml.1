Return-Path: <linux-kernel-owner+w=401wt.eu-S1755189AbZIPDq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189AbZIPDq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 23:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754927AbZIPDqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 23:46:54 -0400
Received: from mail-qy0-f172.google.com ([209.85.221.172]:51794 "EHLO
	mail-qy0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbZIPDqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 23:46:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QL8DWivBJciRKEQdLOMeSJT3W3YbyD0TW6ZJIe7FYWmRugd1PHlxwEUa0alV6014h6
         9MQptCjV6JMozMc1IWkJMlie+KvcFx/3dRD3p5vCcgYHwjTr0ng1bY9fyMZjnV9L+0v0
         YYO2NRe8JqwMeIuy2M8l3H9wF589ZXiBn8UYk=
Date: Tue, 15 Sep 2009 20:46:50 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: 2.6.32 -mm merge plans
Message-ID: <20090916034650.GD2756@core.coreip.homeip.net>
References: <20090915161535.db0a6904.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090915161535.db0a6904.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Tue, Sep 15, 2009 at 04:15:35PM -0700, Andrew Morton wrote:
> 
> input-touchpad-not-detected-on-asus-g1s.patch

This one has been in mainline for a while now, please drop.

> input-add-a-shutdown-method-to-pnp-drivers.patch

This should go through PNP tree (do we have one?).

-- 
Dmitry
