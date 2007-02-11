Return-Path: <linux-kernel-owner+w=401wt.eu-S1750737AbXBKRIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750737AbXBKRIu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 12:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750738AbXBKRIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 12:08:50 -0500
Received: from wr-out-0506.google.com ([64.233.184.225]:53386 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbXBKRIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 12:08:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MZO2ipgwYbGr+XfK6ZWrg26ijCXdc+Vcj6HBc1BSmPYh9QMYqjqs+dJvH/EE9L4rm4klWpU1SH/sNj5l5Se59bYY5S8maX3szgM+1b2roj3mgnlnap8lXoszYYv1N7CeJzTiwaU4ttdOMngwbnqN+pmTfCyqQkww5SCWj3yCJuo=
Message-ID: <8474209b0702110908o20f7c0cey3209b60610270db9@mail.gmail.com>
Date: Sun, 11 Feb 2007 19:08:47 +0200
From: "Alex Bounder" <abounder@gmail.com>
To: "Jan Engelhardt" <jengelh@linux01.gwdg.de>
Subject: Re: creating headless device on 2.6.18
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.61.0702081944230.1364@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8474209b0702081005t196c64bajbf94f119e4ed32e@mail.gmail.com>
	 <Pine.LNX.4.61.0702081944230.1364@yvahk01.tjqt.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>
> V4L2 is something different. Turn on EMBEDDED, then you should be able to
> deactivate VGA_CONSOLE.
>
>
> Jan

Thanks,
 I really appreciate your answer, everything is working ok.
