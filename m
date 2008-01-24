Return-Path: <linux-kernel-owner+w=401wt.eu-S1755630AbYAXOx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630AbYAXOx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 09:53:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbYAXOxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 09:53:51 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:44345 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588AbYAXOxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 09:53:50 -0500
Date: Thu, 24 Jan 2008 17:53:32 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Ville =?utf-8?B?U3lyasOkbMOk?= <syrjala@sci.fi>,
       David Fries <david@fries.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] W1: w1_therm.c standardize units to millidegrees C
Message-ID: <20080124145332.GA24193@2ka.mipt.ru>
References: <20080124020330.GA19155@spacedout.fries.net> <20080124123909.GY30987@sci.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080124123909.GY30987@sci.fi>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2008 at 02:39:09PM +0200, Ville Syrjälä (syrjala@sci.fi) wrote:
> Why isn't w1_therm presented as a hwmon device?

First, because it was created way earlier, second, because it is not a
hardware monitor :)
Feel free to create a driver to bind thermal sensors to hwmon framework,
but I'm not sure it worth time.

-- 
	Evgeniy Polyakov
