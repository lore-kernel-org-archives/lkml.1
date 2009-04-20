Return-Path: <linux-kernel-owner+w=401wt.eu-S1758041AbZDTWzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041AbZDTWzc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 18:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756646AbZDTWzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 18:55:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55557 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756499AbZDTWzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 18:55:14 -0400
Date: Mon, 20 Apr 2009 15:35:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David VomLehn <dvomlehn@cisco.com>
Cc: stern@rowland.harvard.edu, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [Patch] Wait for console to become available, ver 3
Message-Id: <20090420153501.8068955f.akpm@linux-foundation.org>
In-Reply-To: <20090420222948.GA11068@cuplxvomd02.corp.sa.net>
References: <20090420143010.697c7380.akpm@linux-foundation.org>
	<Pine.LNX.4.44L0.0904201744410.6832-100000@iolanthe.rowland.org>
	<20090420222948.GA11068@cuplxvomd02.corp.sa.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Apr 2009 15:29:48 -0700
David VomLehn <dvomlehn@cisco.com> wrote:

> I do agree with the idea of adding one boot parameter rather than two.

zero parameters if at all possible, please...
