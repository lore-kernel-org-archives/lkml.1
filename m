Return-Path: <linux-kernel-owner+w=401wt.eu-S1760248AbYAYUjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760248AbYAYUjT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 15:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753984AbYAYUjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 15:39:06 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:54579 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835AbYAYUjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 15:39:05 -0500
Date: Fri, 25 Jan 2008 12:38:56 -0800
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Kurt Hackel <kurt.hackel@oracle.com>
Subject: Re: [PATCH 093/196] kset: convert ocfs2 to use kset_create
Message-ID: <20080125203856.GX23506@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
References: <20080125071127.GA4860@kroah.com> <1201246425-5058-14-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201246425-5058-14-git-send-email-gregkh@suse.de>
Organization: Oracle Corporation
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2008 at 11:32:02PM -0800, Greg Kroah-Hartman wrote:
> Dynamically create the kset instead of declaring it statically.
> 
> Also use the new kobj_attribute which cleans up this file a _lot_.
> 
> Cc: Kay Sievers <kay.sievers@vrfy.org>
> Cc: Mark Fasheh <mark.fasheh@oracle.com>
> Cc: Kurt Hackel <kurt.hackel@oracle.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Acked-by: Mark Fasheh <mark.fasheh@oracle.com>

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
