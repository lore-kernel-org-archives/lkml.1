Return-Path: <linux-kernel-owner+w=401wt.eu-S965357AbXBLTyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965357AbXBLTyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 14:54:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965358AbXBLTyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 14:54:43 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:32299 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965357AbXBLTym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 14:54:42 -0500
Subject: Re: [PATCH mm] cfag12864b: fix crash when built-in and no parport
	present
From: Daniel Walker <dwalker@mvista.com>
To: Miguel Ojeda <maxextreme@gmail.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070210205123.699abb9c.maxextreme@gmail.com>
References: <20070210205123.699abb9c.maxextreme@gmail.com>
Content-Type: text/plain
Date: Mon, 12 Feb 2007 11:52:50 -0800
Message-Id: <1171309970.32073.115.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-02-10 at 20:51 +0100, Miguel Ojeda wrote:
> Andrew, Daniel who reported the crash has tested this patch and says that it works fine avoiding it, so you can merge.
> 

Yes, I tested it with the ks0108 enabled alone, and with both ks0108 and
CFAG12864B .. Both booted fully..

Daniel

