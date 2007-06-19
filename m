Return-Path: <linux-kernel-owner+w=401wt.eu-S932530AbXFSC6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530AbXFSC6N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 22:58:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762855AbXFSC6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 22:58:03 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762703AbXFSC6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 22:58:01 -0400
Subject: Re: [RFC] Generic Trace Setup and Control (GTSC) kernel API (2/3)
From: Martin Hunt <hunt@redhat.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: David Wilder <dwilder@us.ibm.com>, linux-kernel@vger.kernel.org,
       systemtap@sources.redhat.com
In-Reply-To: <20070618194301.GA6038@martell.zuzino.mipt.ru>
References: <4676108B.9030203@us.ibm.com>
	 <20070618194301.GA6038@martell.zuzino.mipt.ru>
Content-Type: text/plain
Organization: Red Hat Inc.
Date: Mon, 18 Jun 2007 21:31:44 -0400
Message-Id: <1182216704.4147.6.camel@dragon>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-18 at 23:43 +0400, Alexey Dobriyan wrote:
> 
> Can we get another user to justify this generalizing?

Systemtap will be using this. Most users of the relay interface will
need to duplicate much of the functionality of GTSC so I expect others
will use it when it is available.



