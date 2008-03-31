Return-Path: <linux-kernel-owner+w=401wt.eu-S1757013AbYCaT4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013AbYCaT4l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 15:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751682AbYCaT4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 15:56:30 -0400
Received: from main.gmane.org ([80.91.229.2]:46074 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753927AbYCaT4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 15:56:12 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Wes Felter <wesley@felter.org>
Subject: Re: [PATCH 1/2] Define sysfs interfaces for ibmaem driver
Date: Mon, 31 Mar 2008 14:55:52 -0500
Message-ID: <47F141C8.50401@felter.org>
References: <20080328213646.GC7191@tree.beaverton.ibm.com> <20080329145603.7e47418f@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: bi01p1.co.us.ibm.com
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
In-Reply-To: <20080329145603.7e47418f@hyperion.delvare>
Cc: lm-sensors@lm-sensors.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:

> On Fri, 28 Mar 2008 14:36:46 -0700, Darrick J. Wong wrote:

>> +energy[1-*]_input		Instantaneous energy use
> 
> This doesn't make sense to me. Energy is a quantity, it exists
> independently of time. An "instantaneous energy use" only makes sense
> if you tell in what (presumably very small) amount of time the energy
> was used... and then what you are measuring is not an energy but a
> power, for which we already have an interface. Please clarify.

I agree. May I suggest "cumulative energy use"?

Wes Felter - wesley@felter.org

