Return-Path: <linux-kernel-owner+w=401wt.eu-S1756891AbYLaUfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891AbYLaUfs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 15:35:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbYLaUfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 15:35:40 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:28472 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbYLaUfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 15:35:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=cMD2FuVBPxeyEtQ+dC3sq5Q4SE+rNrbPpwR22tAe6OyrslOuv6ywz6pVbMbthrVx1X
         g3medoWyeQVl/yshJDc7txlDj7RC/ne+G29LzTIhQ0gRjY2ywmnJOY6wY4EskxmIUDUk
         yPYsvlN2un9ir5LaEXlJ3XY1qKnANJ8fBaDpU=
Message-ID: <495BD796.5020609@gmail.com>
Date: Wed, 31 Dec 2008 12:35:34 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: uvcvideo: UVC non compliance  - GET_DEF(PROBE)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is what I get with the latest git:
dmesg | grep uvc

[   11.797824] uvcvideo: Found UVC 1.00 device Built-in iSight (05ac:8501)
[   11.810472] uvcvideo: UVC non compliance - GET_DEF(PROBE) not 
supported. Enabling workaround.
[   11.821440] usbcore: registered new interface driver uvcvideo

I don't have a problem with it enabling a workaround,
it's just the whinnying noise I get with my box.
(sounds like morse code);
As soon as the isight.fw is loaded(with past kernels) the morse code sound
from the machine disappears.

regards;

Justin P. Mattock
