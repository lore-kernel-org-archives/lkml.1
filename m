Return-Path: <linux-kernel-owner+w=401wt.eu-S1161166AbXBOUWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161166AbXBOUWf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 15:22:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161172AbXBOUWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 15:22:34 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:55172 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161169AbXBOUWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 15:22:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=b3zqazjrthZkDp4lQIEp89FI9Z7MrNWhBxIslSkC9JNEnzyI6JfnPdurKl3a0FaCVxohCpCHyKUPurXJDKHd8SQDWFDeRTw/QSjnCBTdu9JXqYWB0Vi61X7iejLlPM3Lb5Ui34WY/68xebUoLAAhCQBYzlNSnhtVY+u31iKDioM=
Message-ID: <d120d5000702151222o6957e089jf3b682d51ff94181@mail.gmail.com>
Date: Thu, 15 Feb 2007 15:22:16 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Helge Deller" <deller@gmx.de>
Subject: Re: [PATCH] HIL: fix improper call of release_region v2
Cc: "Cyrill V. Gorcunov" <gorcunov@gmail.com>, "Andrew Morton" <akpm@osdl.org>,
       linux-kernel-list <linux-kernel@vger.kernel.org>
In-Reply-To: <200702152031.40145.deller@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070215192513.GA12857@cvg> <200702152031.40145.deller@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/15/07, Helge Deller <deller@gmx.de> wrote:
> On Thursday 15 February 2007, Cyrill V. Gorcunov wrote:
> > Thist patch prevents from improper call of release_region
> > if the code has been compiled without CONFIG_HP300 support.
> >
> > Signed-off-by: Cyrill V. Gorcunov <gorcunov@gmail.com>
>
> Acked-by: Helge Deller <deller@gmx.de>
>

Will apply, thanks.

-- 
Dmitry
