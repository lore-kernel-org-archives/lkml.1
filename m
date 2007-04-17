Return-Path: <linux-kernel-owner+w=401wt.eu-S1031209AbXDQUuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031209AbXDQUuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 16:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031211AbXDQUuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 16:50:11 -0400
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:52144 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031209AbXDQUuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 16:50:09 -0400
Date: Tue, 17 Apr 2007 16:50:06 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Casey Schaufler <casey@schaufler-ca.com>
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: AppArmor FAQ
In-Reply-To: <657751.18080.qm@web36614.mail.mud.yahoo.com>
Message-ID: <Line.LNX.4.64.0704171647020.20447@d.namei>
References: <657751.18080.qm@web36614.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2007, Casey Schaufler wrote:

> those names it cares about. SELinux in the absence of a correct and
> complete policy could be considered dangerous.

It should be noted that SELinux is only recommended as an addition to DAC, 
not a replacement, so that it can only further restrict existing access 
control.


- James
-- 
James Morris
<jmorris@namei.org>
