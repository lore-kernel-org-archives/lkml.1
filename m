Return-Path: <linux-kernel-owner+w=401wt.eu-S1759865AbYHHTH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759865AbYHHTH7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 15:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755198AbYHHTHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 15:07:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:36368 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463AbYHHTHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 15:07:50 -0400
Date: Fri, 8 Aug 2008 12:04:48 -0700
From: Greg KH <greg@kroah.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, sailer@watson.ibm.com, zohar@us.ibm.com
Subject: Re: [PATCH 2/4] integrity: special fs magic
Message-ID: <20080808190448.GA3356@kroah.com>
References: <20080808184349.999902616@linux.vnet.ibm.com> <1218221742.4444.12.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218221742.4444.12.camel@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2008 at 02:55:42PM -0400, Mimi Zohar wrote:
>     - Move special fs magic number definitions to magic.h
>     - Add magic.h include
>     
>     Signed-off-by: Mimi Zohar <zohar@us.ibm.com>

Why?  What is this patch for?  Are you going to do something with these
magic values later?

thanks,

greg k-h
