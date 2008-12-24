Return-Path: <linux-kernel-owner+w=401wt.eu-S1752117AbYLXQUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbYLXQUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 11:20:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751183AbYLXQUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 11:20:39 -0500
Received: from mx2.redhat.com ([66.187.237.31]:38341 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079AbYLXQUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 11:20:39 -0500
Date: Wed, 24 Dec 2008 17:18:51 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: ebiederm@xmission.com, roland@redhat.com, bastian@waldi.eu.org,
       daniel@hozac.com, xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 6/7][v4] SI_USER: Masquerade si_pid when crossing
	pid ns boundary
Message-ID: <20081224161851.GD11593@redhat.com>
References: <20081224114414.GA7879@us.ibm.com> <20081224115301.GF8020@us.ibm.com> <20081224154310.GA11593@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081224154310.GA11593@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24, Oleg Nesterov wrote:
>
> ? Why should we check SI_USER and change sys_kill() ?
                                ^^^^^^^^^^^^^^^^^^^
I'm afraid I wasn't clear...

> see also the comment for the next 7/7 patch.

yes, please see the next comment.

Oleg.

