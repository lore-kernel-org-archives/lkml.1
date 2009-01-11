Return-Path: <linux-kernel-owner+w=401wt.eu-S1752015AbZAKGHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbZAKGHU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 01:07:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751082AbZAKGHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 01:07:05 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55541 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbZAKGHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 01:07:04 -0500
Date: Sun, 11 Jan 2009 07:04:52 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: ebiederm@xmission.com, roland@redhat.com, bastian@waldi.eu.org,
       daniel@hozac.com, xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7][v6] Container-init signal semantics
Message-ID: <20090111060452.GA9014@redhat.com>
References: <20090107074558.GA27881@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107074558.GA27881@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric, Roland, what do you think ?

The whole series looks good to me. I think it adds minimal
complications to solove the problem.

Oleg.

