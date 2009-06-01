Return-Path: <linux-kernel-owner+w=401wt.eu-S1759129AbZFAUmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759129AbZFAUmi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 16:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756112AbZFAUm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 16:42:29 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:50958 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152AbZFAUm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 16:42:29 -0400
Subject: Re: [PATCH]:Return proper error value on failure of dentry_open
From: Jon Masters <jonathan@jonmasters.org>
To: vibi_sreenivasan@cms.com
Cc: Mimi Zohar <zohar@us.ibm.com>, Kylene Hall <kylene@us.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>, Reiner Sailer <sailer@watson.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1243836708.2163.3.camel@system>
References: <1243836708.2163.3.camel@system>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Mon, 01 Jun 2009 16:37:54 -0400
Message-Id: <1243888674.31439.26.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-01 at 11:41 +0530, vibi sreenivasan wrote:
> dentry_open can return error value on error.
>     Check that value before calling fput & return proper error value

I know you're going to redo this patch. Could you please also post with
a better subject next time? :)

Jon.


