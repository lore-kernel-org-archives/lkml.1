Return-Path: <linux-kernel-owner+w=401wt.eu-S1751931Ab0ATNZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931Ab0ATNZT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 08:25:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288Ab0ATNZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 08:25:14 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:39631 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab0ATNZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 08:25:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ggmQitqWV5YFMuhqjlj4j5oMf+q9AL0H0/5DKKg5Z2raauva6f/2Io9AXVcjDZYAdq
         gIbWQTW/KtoP0aRINNRnt/hAmpprUXnO/sulPDLFNqpV1vv9QC+qDF0gV215JJq5H4DN
         E9D1pDv+Giy5CIvhmj2GZkBCZDX9iefaVheM0=
Subject: Re: sched: Remove USER_SCHED
From: Dhaval Giani <dhaval.giani@gmail.com>
To: a.p.zijlstra@chello.nl
Cc: mingo@elte.hu, bharata@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com
In-Reply-To: <1263990378.24844.3.camel@localhost>
References: <1263990378.24844.3.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jan 2010 14:25:05 +0100
Message-ID: <1263993905.24844.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-20 at 13:26 +0100, Dhaval Giani wrote:
> Remove the USER_SCHED feature. It has been scheduled to be removed in 2.6.34
> as per http://marc.info/?l=linux-kernel&m=125728479022976&w=2
> 
> Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>

Sorry, this is no longer correct. Corrected sign-off follows!

Signed-off-by: Dhaval Giani <dhaval.giani@gmail.com>

