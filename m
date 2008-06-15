Return-Path: <linux-kernel-owner+w=401wt.eu-S1759389AbYFOPHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759389AbYFOPHp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 11:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758227AbYFOPHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 11:07:37 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:27070 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758146AbYFOPHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 11:07:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=bs0d6NIjfLju7SalzVqljqq7s2aLQGG7AdI3LQpL1nenUAckTWpeXMdHH9sT9n6Tax
         OE11WefSDBDrpDWs7znByWwMMZt1BQYgT8p8I+G+ZO+RtWCblc3GxGQhdlrb/5YNc+a1
         lZ9eaR9nxu/8QxY/gqy0zwLPFZuDy0KAjofpk=
Message-ID: <2f11576a0806150807v2130cfbdl7a6f556c4bebaa62@mail.gmail.com>
Date: Mon, 16 Jun 2008 00:07:34 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Rik van Riel" <riel@redhat.com>
Subject: Re: [PATCH] fix printk in show_free_areas
Cc: "Hiroshi Shimamoto" <h-shimamoto@ct.jp.nec.com>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Lee Schermerhorn" <lee.schermerhorn@hp.com>
In-Reply-To: <20080613134827.5dbac5ac@cuia.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080611184214.605110868@redhat.com>
	 <20080611184339.159161465@redhat.com> <4851C1CC.7070607@ct.jp.nec.com>
	 <20080613134827.5dbac5ac@cuia.bos.redhat.com>
X-Google-Sender-Auth: ed46bbdb0229c793
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -       printk("Active_anon:%lu active_file:%lu inactive_anon%lu\n"
> +       printk("Active_anon:%lu active_file:%lu inactive_anon:%lu\n"

Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
