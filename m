Return-Path: <linux-kernel-owner+w=401wt.eu-S933994AbYEBLJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933994AbYEBLJe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 07:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760834AbYEBLJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 07:09:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37789
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759786AbYEBLJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 07:09:26 -0400
Date: Fri, 02 May 2008 04:09:26 -0700 (PDT)
Message-Id: <20080502.040926.186644792.davem@davemloft.net>
To: den@openvz.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       adobriyan@openvz.org, ebiederm@xmission.com, kaber@trash.net
Subject: Re: [PATCH 6/12] vlan: assign PDE->data before gluing PDE into
 /proc tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <1209467602-20001-6-git-send-email-den@openvz.org>
References: <1209467538.29647.11.camel@iris.sw.ru>
	<1209467602-20001-6-git-send-email-den@openvz.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Denis V. Lunev" <den@openvz.org>
Date: Tue, 29 Apr 2008 15:13:16 +0400

> Simply replace proc_create and further data assigned with proc_create_data.
> 
> Signed-off-by: Denis V. Lunev <den@openvz.org>
> Cc: Alexey Dobriyan <adobriyan@openvz.org>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Patrick McHardy <kaber@trash.net>

Applied, with Patrick's ACK.

Thanks.
