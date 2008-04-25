Return-Path: <linux-kernel-owner+w=401wt.eu-S1755380AbYDYDQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380AbYDYDQg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 23:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbYDYDQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 23:16:27 -0400
Received: from 166-70-57-16.ip.xmission.com ([166.70.57.16]:59862 "EHLO
	mail.bakbone.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751506AbYDYDQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 23:16:26 -0400
X-Greylist: delayed 2926 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Apr 2008 23:16:26 EDT
From: Justin Banks <justinb@bakbone.com>
Date: Thu, 24 Apr 2008 20:27:26 -0600
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Soeren Sandmann <sandmann@daimi.au.dk>, linux-kernel@vger.kernel.org
Subject: Re: stat benchmark
Message-ID: <20080425022726.GA4034@bleen.gateway.2wire.net>
References: <ye8wsmnezq9.fsf@camel05.daimi.au.dk> <alpine.LNX.1.10.0804242329060.11644@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0804242329060.11644@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote
> 
> XFS for example already has bulkstat, but it is not really
> exported to userspace :-/

Perhaps this could be in VFS, and used if present?

-justinb

-- 
Justin Banks
BakBone Software
justinb@bakbone.com
