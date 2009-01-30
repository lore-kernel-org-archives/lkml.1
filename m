Return-Path: <linux-kernel-owner+w=401wt.eu-S1757255AbZA3W53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255AbZA3W53 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 17:57:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbZA3W5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 17:57:21 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:58583 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbZA3W5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 17:57:21 -0500
Date: Fri, 30 Jan 2009 23:59:08 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: headers check garble latest git
Message-ID: <20090130225908.GB17950@uranus.ravnborg.org>
References: <4983553A.2010804@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4983553A.2010804@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 30, 2009 at 11:30:02AM -0800, Justin P. Mattock wrote:
> when compiling the kernel I see lots
> of this:

Jaswinder has fixed the relvant warnings already - patchs are heading
towards mainline. The final patch kills the check again as it turned
out to be too agressive.

	Sam
