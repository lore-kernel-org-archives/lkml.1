Return-Path: <linux-kernel-owner+w=401wt.eu-S1755529AbYG2X7D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbYG2X7D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 19:59:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752746AbYG2X6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 19:58:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53129 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752330AbYG2X6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 19:58:53 -0400
Date: Tue, 29 Jul 2008 16:57:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nicolas Boichat <nicolas@boichat.ch>
Cc: mhoffman@lightlink.com, roberto@unbit.it,
       mactel-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       khali@linux-fr.org, lm-sensors@lm-sensors.org,
       guilherme.m.schroeder@gmail.com
Subject: Re: [PATCH 2/2] applesmc: add support for Macbook v3.
Message-Id: <20080729165756.48dc9d39.akpm@linux-foundation.org>
In-Reply-To: <488F323E.6040403@boichat.ch>
References: <1216814135.5834.9.camel@sirius>
	<488F30F7.4030804@boichat.ch>
	<488F323E.6040403@boichat.ch>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2008 23:07:42 +0800
Nicolas Boichat <nicolas@boichat.ch> wrote:

> 
> This patches adds support for Macbook v3 (sensors and accelerometer).

Anally changed to "Add support for ...".  There is no need to put the
text "This patch ..." in a changelog.

> From: guilherme m. schroeder <guilherme.m.schroeder@gmail.com>
> Signed-off-by: Nicolas Boichat <nicolas@boichat.ch>

Nope.  The way to signify authorship is to put a From: line right at
the very start of the email.  If that line is missing, we'll fall back
to using the email headers to determins the authorship.

