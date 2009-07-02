Return-Path: <linux-kernel-owner+w=401wt.eu-S1754062AbZGBAuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062AbZGBAuQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 20:50:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752395AbZGBAuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 20:50:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565AbZGBAuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 20:50:04 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Oren Laadan <orenl@cs.columbia.edu>, serue@us.ibm.com,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Containers <containers@lists.linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Disable CLONE_PARENT for init
In-Reply-To: Sukadev Bhattiprolu's message of  Wednesday, 1 July 2009 17:35:20 -0700 <20090702003520.GA26247@us.ibm.com>
References: <20090701073140.GA14284@us.ibm.com>
	<20090701074654.A6C6321D57@magilla.sf.frob.com>
	<20090701082452.GA3297@redhat.com>
	<20090701214805.GA25734@us.ibm.com>
	<20090701215833.876DA404FD@magilla.sf.frob.com>
	<20090702003520.GA26247@us.ibm.com>
X-Zippy-Says: ...Um...Um...
Message-Id: <20090702004938.47C9D404FD@magilla.sf.frob.com>
Date: Wed,  1 Jul 2009 17:49:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me.

Acked-by: Roland McGrath <roland@redhat.com>
