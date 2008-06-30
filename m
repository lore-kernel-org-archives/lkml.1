Return-Path: <linux-kernel-owner+w=401wt.eu-S1760718AbYF3KQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760718AbYF3KQz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 06:16:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755778AbYF3KQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 06:16:47 -0400
Received: from namei.org ([69.55.235.186]:60279 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755462AbYF3KQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 06:16:46 -0400
Date: Mon, 30 Jun 2008 20:06:19 +1000 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>,
       Reiner Sailer <sailer@us.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [RFC][PATCH 3/5] integrity: special fs magic
In-Reply-To: <1214583768.28077.16.camel@new-host.home>
Message-ID: <Xine.LNX.4.64.0806302006040.23266@us.intercode.com.au>
References: <20080627131946.225566613@linux.vnet.ibm.com>
 <1214583768.28077.16.camel@new-host.home>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2008, Mimi Zohar wrote:

> - Move special fs magic number definitions to magic.h
> - Add magic.h include
> 
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>

Reviewed-by: James Morris <jmorris@namei.org>


-- 
James Morris
<jmorris@namei.org>
