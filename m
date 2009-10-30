Return-Path: <linux-kernel-owner+w=401wt.eu-S1751027AbZJ3ECV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751027AbZJ3ECV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 00:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750794AbZJ3ECV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 00:02:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbZJ3ECU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 00:02:20 -0400
Subject: Re: [BUG? -next] Compile tpm driver as module
From: Eric Paris <eparis@redhat.com>
To: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Cc: Mimi Zohar <zohar@us.ibm.com>, LKLM <linux-kernel@vger.kernel.org>,
       James Morris <jmorris@namei.org>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
In-Reply-To: <4AEA474B.8060904@np.css.fujitsu.com>
References: <4AEA474B.8060904@np.css.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Oct 2009 00:02:18 -0400
Message-Id: <1256875338.3498.9.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-30 at 10:54 +0900, Jin Dongming wrote:
> When we compiled tpm driver as module in the next-tree, some errors happened.
> The output error messages is showed as following:

Fixed by:
http://git.kernel.org/?p=linux/kernel/git/jmorris/security-testing-2.6.git;a=commitdiff;h=ff76ec18cabb12a6c8f3c65bd1d23f1a770fe908

Should be in -next today/tomorrow.

-Eric

