Return-Path: <linux-kernel-owner+w=401wt.eu-S1755993AbYCTMpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbYCTMpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 08:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753179AbYCTMov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 08:44:51 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:14990 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753015AbYCTMou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 08:44:50 -0400
Date: Thu, 20 Mar 2008 15:39:16 +0300
From: Dmitri Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] Fix data leak in nobh_write_end.
Message-ID: <20080320123916.GA19995@dmon-lap.sw.ru>
Mail-Followup-To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20080320122953.GA19928@dmon-lap.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080320122953.GA19928@dmon-lap.sw.ru>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15:29 Thu 20 Mar     , root wrote:
Opps.. sorry for incorrectly filled "FROM:" filed, email was from me.
