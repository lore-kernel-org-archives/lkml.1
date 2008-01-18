Return-Path: <linux-kernel-owner+w=401wt.eu-S1764220AbYARRbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764220AbYARRbL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 12:31:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760959AbYARRaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 12:30:55 -0500
Received: from mx01.xsigo.com ([216.184.49.20]:55979 "EHLO mx01.xsigo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760899AbYARRay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 12:30:54 -0500
X-Greylist: delayed 1221 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jan 2008 12:30:54 EST
Subject: Re: [ofa-general] InfiniBand/RDMA merge plans for 2.6.25
From: Hal Rosenstock <hrosenstock@xsigo.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
In-Reply-To: <ada7ii8xaao.fsf@cisco.com>
References: <ada7ii8xaao.fsf@cisco.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 18 Jan 2008 09:10:32 -0800
Message-Id: <1200676232.1486.88.camel@hrosenstock-ws.xsigo.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-01-17 at 16:11 -0800, Roland Dreier wrote:
> Here all the patches I already have in my for-2.6.25 branch:
> Sean Hefty (6):
>       IB/mad: Fix incorrect access to items on local_list

It wasn't clear to me that this issue was ever really nailed. Was the
loop on this closed ?

-- Hal

