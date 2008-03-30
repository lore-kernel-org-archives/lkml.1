Return-Path: <linux-kernel-owner+w=401wt.eu-S1753847AbYC3Lev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbYC3Lev (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 07:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbYC3Len
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 07:34:43 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:43977 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751463AbYC3Lem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 07:34:42 -0400
Date: Sun, 30 Mar 2008 15:34:35 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: David Fries <david@fries.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/35] W1: w1_therm fix user buffer overflow and cat
Message-ID: <20080330113435.GI15122@2ka.mipt.ru>
References: <200803272343.m2RNhDac017650@SpacedOut.fries.net> <20080328122626.GQ3613@spacedout.fries.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080328122626.GQ3613@spacedout.fries.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

14-16 patches are a bug fixes (for the same problem though), please
combine them into single patch.
Thank you.

On Fri, Mar 28, 2008 at 07:26:26AM -0500, David Fries (david@fries.net) wrote:
> This switches w1_therm from bin_attribute to device_attribute which
> fixes a buffer overflow and some bad behavior.

-- 
	Evgeniy Polyakov
