Return-Path: <linux-kernel-owner+w=401wt.eu-S1760040AbYAYSRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760040AbYAYSRY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 13:17:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756242AbYAYSRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 13:17:04 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39181 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756352AbYAYSRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 13:17:01 -0500
Date: Fri, 25 Jan 2008 10:17:01 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Greg Kroah-Hartman <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 135/196] Kobject: convert mm/slub.c to use kobject_init/add_ng()
In-Reply-To: <1201246425-5058-56-git-send-email-gregkh@suse.de>
Message-ID: <Pine.LNX.4.64.0801251016460.672@schroedinger.engr.sgi.com>
References: <20080125071127.GA4860@kroah.com> <1201246425-5058-56-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jan 2008, Greg Kroah-Hartman wrote:

> This converts the code to use the new kobject functions, cleaning up the
> logic in doing so.

Acked-by: Christoph Lameter <clameter@sgi.com>

