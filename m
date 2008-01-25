Return-Path: <linux-kernel-owner+w=401wt.eu-S1759916AbYAYSQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759916AbYAYSQt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 13:16:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759516AbYAYSQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 13:16:36 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39163 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759498AbYAYSQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 13:16:34 -0500
Date: Fri, 25 Jan 2008 10:16:33 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Greg Kroah-Hartman <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 067/196] kset: convert slub to use kset_create
In-Reply-To: <1201245134-4876-67-git-send-email-gregkh@suse.de>
Message-ID: <Pine.LNX.4.64.0801251015580.672@schroedinger.engr.sgi.com>
References: <20080125071127.GA4860@kroah.com> <1201245134-4876-67-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jan 2008, Greg Kroah-Hartman wrote:

> Dynamically create the kset instead of declaring it statically.

Cannot see anything wrong (but then sysfs is mainly a mystery to 
me)

Acked-by: Christoph Lameter <clameter@sgi.com>
